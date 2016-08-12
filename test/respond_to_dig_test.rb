$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '../lib'))

require 'minitest'
require 'minitest/autorun'

require 'respond_to_dig'

class RespondToDigTest
  class Diggable
    def dig(*keys)
      keys
    end
  end

  describe RespondToDig do
    let (:an_array) {
      RespondToDig::respond_to_dig(['zero', 'one', 'two'])
    }
    let (:a_nested_array) {
      RespondToDig::respond_to_dig(['zero', ['ten', 'eleven', 'twelve', false], 'two'])
    }
    let (:a_hash) {
      RespondToDig::respond_to_dig({first: "Homer", last: "Simpson", sobber: false})
    }
    let (:a_nested_hash) {
      RespondToDig::respond_to_dig({mom: {first: "Marge", last: "Bouvier"}, dad: {first: "Homer", last: "Simpson"}})
    }
    let (:containing_struct) {
      Dog = Struct.new(:name, :age)
      RespondToDig::respond_to_dig({dogs: [Dog.new("Fred", 5), Dog.new("Harry", 2)]})
    }

    describe "Array" do
      it "digs an array by index" do
        assert_equal 'one', an_array.dig(1)
      end

      it "digs a nested array by index" do
        assert_equal 'twelve', a_nested_array.dig(1, 2)
      end

      it "raises TypeError when nested array doesn't support dig" do
        assert_raises(TypeError) { an_array.dig(1, 2) }
      end

      it "returns nil when dig not found" do
        assert_equal nil, an_array.dig(4)
      end

      it "raises TypeError when dig index not an integer" do
        assert_raises(TypeError) { an_array.dig(:four) }
      end

      it "returns the value false" do
        assert_equal false, a_nested_array.dig(1, 3)
      end
    end

    describe "Hash" do
      it "digs a hash by key" do
        assert_equal 'Homer', a_hash.dig(:first)
      end

      it "digs a nested hash by keys" do
        assert_equal 'Homer', a_nested_hash.dig(:dad, :first)
      end

      it "raises TypeError when nested hash doesn't support dig" do
        assert_raises(TypeError) { a_hash.dig(:first, :foo) }
      end

      it "returns nil when dig not found" do
        assert_equal nil, a_hash.dig(:middle)
      end

      it "digs into any object that implements dig" do
        assert_equal [:a, :b], RespondToDig::respond_to_dig({diggable: Diggable.new}).dig(:diggable, :a, :b)
      end

      it "returns the value false" do
        assert_equal false, a_hash.dig(:sobber)
      end
    end

    describe "Various classes" do
      it "navigates both nested Hash and Array" do
        assert_equal 'Lisa', RespondToDig::respond_to_dig(
          {mom: {first: "Marge", last: "Bouvier"},
           dad: {first: "Homer", last: "Simpson"},
           kids: [{first: "Bart"}, {first: "Lisa"}]}).dig(:kids, 1, :first)
      end

      it "digs into any object that implements dig" do
        assert_equal [:a, :b], RespondToDig::respond_to_dig([0, Diggable.new]).dig(1, :a, :b)
      end

      it "digs into Enumerable object that implements #[]" do
        assert_equal 'Harry', RespondToDig::respond_to_dig(containing_struct).dig(:dogs, 1, :name)
      end
    end
  end

  describe "Alias" do
    it 'alias #invoke' do
      assert_equal RespondToDig.respond_to_dig({}), RespondToDig.invoke({})
    end
    it 'alias #invoke_dig (deprecated)' do
      assert_equal RespondToDig.respond_to_dig({}), RespondToDig.invoke_dig({})
    end
  end
end
