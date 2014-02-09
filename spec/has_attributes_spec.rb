require 'has_attributes'

describe HasAttributes do
  def subclass_model(model, *attrs)
    Class.new(model) do
      include HasAttributes
      has_attributes *attrs
    end
  end

  def create_model(*attrs)
    Class.new do
      include HasAttributes
      has_attributes *attrs
    end
  end

  describe ".has_attributes" do
    context "with a single class" do
      let(:klass) { create_model :attr1, :attr2 }

      it "adds the attributes to the model_attributes accessor" do
        expect(klass.model_attributes).to eq(Set.new [:attr1, :attr2])
      end

      it "defines attributes accessors" do
        expect(klass.public_method_defined?(:attr1)).to be_true
        expect(klass.public_method_defined?(:attr1=)).to be_true

        expect(klass.public_method_defined?(:attr2)).to be_true
        expect(klass.public_method_defined?(:attr2=)).to be_true
      end
    end

    context "when subclassing" do
      let(:parent) { create_model :attr1, :attr2 }

      context "when inheriting parent attributes" do
        let(:child) { subclass_model parent, :attr3 }

        it "adds the attributes of both parent and child to the model_attributes accessor" do
          expect(child.model_attributes).to eq(Set.new [:attr1, :attr2, :attr3])
        end

        it "defines new accessors in addition to the parent accessors" do
          expect(child.public_method_defined?(:attr1)).to be_true
          expect(child.public_method_defined?(:attr1=)).to be_true

          expect(child.public_method_defined?(:attr2)).to be_true
          expect(child.public_method_defined?(:attr2=)).to be_true

          expect(child.public_method_defined?(:attr3)).to be_true
          expect(child.public_method_defined?(:attr3=)).to be_true
        end
      end

      context "when not inheriting parent attributes" do
        let(:child) { subclass_model parent, :attr3, inherit: false }

        it "adds attributes of the child only to the model_attributes accessor" do
          expect(child.model_attributes).to eq(Set.new [:attr3])
        end

        it "defines new accessors only" do
          expect(child.public_method_defined?(:attr1)).to be_false
          expect(child.public_method_defined?(:attr1=)).to be_false

          expect(child.public_method_defined?(:attr2)).to be_false
          expect(child.public_method_defined?(:attr2=)).to be_false

          expect(child.public_method_defined?(:attr3)).to be_true
          expect(child.public_method_defined?(:attr3=)).to be_true
        end
      end
    end
  end

  describe "#attributes" do
    let(:klass) { create_model :attr1, :attr2 }

    it "returns an empty hash when no attributes were defined" do
      instance = Class.new { include HasAttributes }.new

      instance.attributes = {a: true, b: false}
      expect(instance.attributes).to eq({})
    end

    it "sets a hash of attributes on the instance" do
      instance = klass.new

      instance.attributes = {attr1: true, attr2: false}

      expect(instance.attr1).to be_true
      expect(instance.attr2).to be_false

      expect(instance.attributes).to eq(attr1: true, attr2: false)
    end

    it "overrides existing values" do
      instance = klass.new
      instance.attr1 = true

      instance.attributes = {attr2: false}

      expect(instance.attr1).to be_nil
      expect(instance.attr2).to be_false

      expect(instance.attributes).not_to include(:attr1)
      expect(instance.attributes).to include(attr2: false)
    end

    it "only sets attributes that were declared with .has_attributes" do
      instance = klass.new

      instance.attributes = {attr1: true, another_attr: false}

      expect(instance.attr1).to be_true
      expect(instance.attr2).to be_nil

      expect(instance.attributes).to include(attr1: true)
      expect(instance.attributes).not_to include(:attr2)
      expect(instance.attributes).not_to include(:another_attr)
    end
  end
end
