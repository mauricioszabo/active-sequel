RSpec.describe "ActiveSequel.get_scopes" do
  let!(:ann) { User.create!(name: "Ann", age: 40, admin: true) }
  let!(:bob) { User.create!(name: "Bob", age: 50) }
  let!(:cid) { User.create!(name: "Cid", age: 20, admin: true) }

  before do
    2.times { |i| ann.posts.create!(title: "a#{i}", published: i.zero?) }
    bob.posts.create!(title: "b")
  end

  let(:scopes) { ActiveSequel.get_scopes(User) }

  it "returns a module with a method per AR scope" do
    expect(scopes).to be_a(Module)
    expect(scopes).to respond_to(:admin, :named, :older_than)
    expect(scopes).not_to respond_to(:published)
    expect(ActiveSequel.get_scopes(Post)).to respond_to(:published)
  end

  it "is cached per model" do
    expect(ActiveSequel.get_scopes(User)).to equal(scopes)
    expect(ActiveSequel.get_scopes(Post)).not_to equal(scopes)
  end

  it "takes the dataset plus the scope's own arguments" do
    expect(scopes.method(:admin).arity).to eq(1)
    expect(scopes.method(:named).arity).to eq(2)
    expect(scopes.method(:older_than).arity).to eq(3)
    expect { scopes.older_than(User.to_dataset, 30) }.to raise_error(ArgumentError)
  end

  it "applies a scope without arguments" do
    ds = scopes.admin(User.to_dataset)
    expect(ds).to be_a(Sequel::Dataset)
    expect(ds.all.map { |r| r[:name] }).to contain_exactly("Ann", "Cid")
  end

  it "applies a scope with two arguments" do
    ds = scopes.older_than(User.to_dataset, 30, 1)
    expect(ds.all.map { |r| r[:id] }).to eq(User.older_than(30, 1).pluck(:id))
    expect(ds.all.map { |r| r[:name] }).to contain_exactly("Ann", "Bob")
  end

  it "composes on top of a dataset built from a relation" do
    base = User.admin.to_dataset
    ds = scopes.older_than(base, 30, 1)
    expect(ds.all.map { |r| r[:name] }).to eq(["Ann"])
  end

  it "can be chained" do
    ds = scopes.named(scopes.admin(User.to_dataset), "Cid")
    expect(ds.all.map { |r| r[:name] }).to eq(["Cid"])
  end
end
