module Gnucash
  describe Book do
    context "with errors" do
      it "raises an error for unexpected XML" do
        gr = "gr"
        expect(Zlib::GzipReader).to receive(:open).and_return(gr)
        expect(gr).to receive(:read).and_return(nil)
        ng = "ng"
        expect(Nokogiri).to receive(:XML).and_return(ng)
        expect(ng).to receive(:xpath).with('/gnc-v2/gnc:book').and_return([])

        expect { Gnucash::Book.new('file name') }.to raise_error "Error: Expected to find one gnc:book entry"
      end
    end

    context "without errors" do
      before(:all) do
        # just open the test file once
        @subject = Gnucash.open("spec/books/sample.gnucash")
      end

      it "records the date of the earliest transaction" do
        expect(@subject.start_date).to eq Date.parse("2007-01-01")
      end

      it "records the date of the last transaction" do
        expect(@subject.end_date).to eq Date.parse("2012-12-28")
      end

      it "lets you find an account by id" do
        expect(@subject.find_account_by_id("67e6e7daadc35716eb6152769373e974").name).to eq "Savings Account"
      end

      it "lets you find an account by full name" do
        expect(@subject.find_account_by_full_name("Assets:Current Assets:Savings Account").id).to eq "67e6e7daadc35716eb6152769373e974"
      end

      it "avoid inspection of heavier attributes" do
        expect(@subject.inspect).to eq "#<Gnucash::Book start_date: 2007-01-01, end_date: 2012-12-28>"
      end
    end

    context "saving" do
      before(:all) do
        # just open the test file once
        @original = Gnucash.open("spec/books/sample-text.gnucash")
        @test_file = 'test-gnucash.xml'
        @test_file_zipped = 'test-gnucash.gz'
        @original.save_as(@test_file)
        @test_content = Gnucash.open(@test_file)
      end

      it "saves the file with the same content and format by default" do
        expect(@test_content.compressed).to eq false
        sha256 = Digest::SHA256.file(@test_content.fname)
        mtime = File.mtime(@test_content.fname)
        @test_content.save_as
        expect(Digest::SHA256.file(@test_content.fname)).to eq sha256
        expect(File.mtime(@test_content.fname)).to be > mtime
      end

      it "is able to save as compressed without changing the content" do
        expect(@test_content.compressed).to eq false
        @test_content.save_as(@test_file_zipped, true)
        @zipped_content = Gnucash.open(@test_file_zipped)
        expect(@zipped_content.compressed).to eq true
        expect(@zipped_content.ng.to_s).to eq @test_content.ng.to_s
      end
    end
  end
end
