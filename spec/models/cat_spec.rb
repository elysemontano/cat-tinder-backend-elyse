RSpec.describe Cat, type: :model do
  it "should validate name" do
    cat = Cat.create
    expect(cat.errors[:name]).to_not be_empty
  end

  it "should have an age" do
    cat = Cat.create(name: 'Tobey', enjoys: 'snuggles and teasing the dog', image: "https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80")
    # If cat's name field is empty throw an error
    expect(cat.errors[:age]).to_not be_empty
  end

  it "should have enjoys" do
    cat = Cat.create(name: 'Tobey', age: 5, image: "https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80")
    # If cat's name field is empty throw an error
    expect(cat.errors[:enjoys]).to_not be_empty
  end

  it "should have an image" do
    cat = Cat.create(name: 'Tobey', age: 5, enjoys: 'snuggles and teasing the dog')
    # If cat's name field is empty throw an error
    expect(cat.errors[:image]).to_not be_empty
  end
end