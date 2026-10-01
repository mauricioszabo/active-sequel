RSpec.describe "ActiveSequel.db" do
  it "is a Sequel database memoized across calls" do
    expect(ActiveSequel.db).to be_a(Sequel::Database)
    expect(ActiveSequel.db).to equal(ActiveSequel.db)
  end

  it "shares the ActiveRecord connection" do
    User.create!(name: "Ann", age: 30)
    expect(ActiveSequel.db[:users].select_map(:name)).to eq(["Ann"])

    ActiveSequel.db[:users].insert(name: "Bob", age: 20)
    expect(User.pluck(:name)).to contain_exactly("Ann", "Bob")
  end

  it "rolls back together with the ActiveRecord transaction" do
    ActiveSequel.db[:users].insert(name: "Tmp")
    expect(User.count).to eq(1)
  end
end
