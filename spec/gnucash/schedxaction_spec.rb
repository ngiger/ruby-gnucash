module Gnucash
  describe Schedxaction do
    
    before(:all) do
      # just read the file once
      @book = Gnucash.open("spec/books/sample-text.gnucash")
      @example1 =  @book.find_schedxaction_by_full_name("ABC Corporation")
      @example2 =  @book.find_schedxaction_by_full_name("XYZ Company")
    end

    it "gives access to the name" do
      expect(@example2.name).to eq "XYZ Company"
    end

    it "gives access to the full name" do
      expect(@example2.full_name).to eq "XYZ Company"
    end

    it "gives access to the id" do
      expect(@example2.id).to eq "4ece5cb8c4907e1de5aa7835faa2b603"
      expect(@example1.id).to eq "209bbfc1c91cb6bf4abe2ed26e11fcf2"
    end

    it "gives access to the start date" do
      expect(@example1.start_date).to eq Date.parse('12.01.2007')
    end

    it "gives access to the end date" do
      expect(@example1.end_date).to  eq Date.parse('2009-06-30')
    end

    it "gives access to the date of last occurrence" do
      expect(@example1.last).to eq Date.parse('2009-06-26')
    end

    it "avoid inspection of heavier attributes" do
      expect(@example1.inspect).to eq "#<Gnucash::Schedxaction id: 209bbfc1c91cb6bf4abe2ed26e11fcf2, name: ABC Corporation, guid: , start_date: 2007-01-12, end_date: 2009-06-30>"
      expect(@example2.inspect).to eq "#<Gnucash::Schedxaction id: 4ece5cb8c4907e1de5aa7835faa2b603, name: XYZ Company, guid: , start_date: 2009-07-10, end_date: 2013-08-11>"
    end
    
    it "allows setting the start date" do
      expect(@example2.start_date).to eq  Date.parse('2009-07-10')
      test_date = '01.01.2018'
      @example2.start_date = test_date
      expect(@example2.start_date).to eq Date.parse(test_date)
    end

    it "allows setting the end date as date" do
      test_date = '31.12.2018'
      @example2.end_date = test_date
      expect(@example2.end_date).to eq Date.parse(test_date)
    end

    it "allows setting the end date as String" do
      test_date = '15.12.2018'
      @example2.end_date = test_date
      expect(@example2.end_date).to eq Date.parse(test_date)
    end

  end
end
