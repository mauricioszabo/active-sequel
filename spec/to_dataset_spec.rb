RSpec.describe "#to_dataset" do
  let!(:ann) { User.create!(name: "Ann", age: 30, admin: true) }
  let!(:bob) { User.create!(name: "Bob", age: 20) }

  it "returns a dataset on the table for a model" do
    ds = User.to_dataset
    expect(ds).to be_a(Sequel::Dataset)
    expect(ds.sql).to eq('SELECT * FROM `users`')
    expect(ds.all.map { |r| r[:name] }).to contain_exactly("Ann", "Bob")
  end

  it "returns a dataset with the relation's query for a relation" do
    relation = User.where(admin: true).order(:name)
    ds = relation.to_dataset
    expect(ds).to be_a(Sequel::Dataset)
    expect(ds.sql).to eq("SELECT * FROM (#{relation.to_sql}) AS `users`")
    expect(ds.all.map { |r| r[:name] }).to eq(["Ann"])
  end

  it "is fully chainable with Sequel methods" do
    ds = User.order(:name).to_dataset
    expect(ds.where(name: "Bob").select_map(:name)).to eq(["Bob"])
    expect(ds.select(:name).order(Sequel.desc(:name)).select_map(:name)).to eq(%w[Bob Ann])
    expect(User.where(admin: false).to_dataset.where(Sequel[:age] > 10).select_map(:name)).to eq(["Bob"])
  end

  it "works with scopes and associations" do
    ann.posts.create!(title: "A", published: true)
    ann.posts.create!(title: "B")

    expect(ann.posts.published.to_dataset.all.map { |r| r[:title] }).to eq(["A"])
    expect(User.admin.to_dataset.all.map { |r| r[:name] }).to eq(["Ann"])
    expect(Post.joins(:user).where(users: {admin: true}).to_dataset.count).to eq(2)
  end
end
