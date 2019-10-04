module Gnucash
  # Represent a GnuCash scheduled action object.
  class Schedxaction
    include Support::LightInspect
    
    Example = %(<gnc:schedxaction version="2.0.0">
  <sx:id type="guid">209bbfc1c91cb6bf4abe2ed26e11fcf2</sx:id>
  <sx:name>ABC Corporation</sx:name>
  <sx:enabled>y</sx:enabled>
  <sx:autoCreate>n</sx:autoCreate>
  <sx:autoCreateNotify>n</sx:autoCreateNotify>
  <sx:advanceCreateDays>0</sx:advanceCreateDays>
  <sx:advanceRemindDays>0</sx:advanceRemindDays>
  <sx:instanceCount>130</sx:instanceCount>
  <sx:start>
    <gdate>2007-01-12</gdate>
  </sx:start>
  <sx:last>
    <gdate>2009-06-26</gdate>
  </sx:last>
  <sx:end>
    <gdate>2009-06-30</gdate>
  </sx:end>
  <sx:templ-acct type="guid">23bea6468ee7b4acb4db4b3f54598a71</sx:templ-acct>
  <sx:schedule>
    <gnc:recurrence version="1.0.0">
      <recurrence:mult>1</recurrence:mult>
      <recurrence:period_type>week</recurrence:period_type>
      <recurrence:start>
        <gdate>2007-01-12</gdate>
      </recurrence:start>
    </gnc:recurrence>
  </sx:schedule>
</gnc:schedxaction>)

    # gnc:GncSchedxactio
    ## name, enabled

    # @return [String] The name of the scheduled action (unqualified).
    attr_reader :id
    attr_reader :name

    # @return [String] The GUID of the scheduled action.
    attr_reader :guid

    # @return [Boolean] The ID of the scheduled action.
    attr_reader :enabled

    # @return [Date] The start date of the scheduled action.
    attr_reader :start_date

    # @return [Date] The end date of the scheduled action.
    attr_reader :end_date

    # @return [Date] The last occurrence of the scheduled action.
    attr_reader :last

    # Create an scheduled action object.
    #
    # @param book [Book] The {Gnucash::Book} containing the scheduled action.
    # @param node [Nokogiri::XML::Node] Nokogiri XML node.
    def initialize(book, node)
      @book = book
      @node = node
      @id = node.xpath('sx:id').text
      @name = node.xpath('sx:name').text
      @enabled = node.xpath('sx:enabled').text
      @last = Date.parse(node.xpath('sx:last/gdate').text)
    end

    def end_date
      Date.parse(@node.xpath('sx:end/gdate').text) if @node.xpath('sx:end/gdate').length > 0
    end
 
    def start_date
      Date.parse(@node.xpath('sx:start/gdate').text) if @node.xpath('sx:start/gdate').length > 0
    end
 
    # Return the fully qualified scheduled action name.
    #
    # @return [String] Fully qualified scheduled action name.
    def full_name
      name
    end

    # Attributes available for inspection
    #
    # @return [Array<Symbol>] Attributes used to build the inspection string
    # @see Gnucash::Support::LightInspect
    def attributes
      %i[id name guid start_date end_date]
    end

    # Set the end_date of the scheduled transaction
    #
    def end_date=(new_end_date)
      @node.xpath('sx:end/gdate').first.content = Date.parse(new_end_date.to_s).strftime('%d-%m-%Y')
    end

    # Set the start_date of the scheduled transaction
    #
    def start_date=(new_start_date)
      @node.xpath('sx:start/gdate').first.content = Date.parse(new_start_date.to_s).strftime('%d-%m-%Y')
    end
  end
end
