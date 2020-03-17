require 'spec_helper'

RSpec.describe RichUrls::QueryInterface do
  it 'registers elements' do
    query_interface = RichUrls::QueryInterface.new
    query_interface.start(:p)
    query_interface.start(:a)
    expect(query_interface.elements.length).to eq(2)
  end

  # structure is like:
  # <p>
  #  <p>
  #   <a></a>
  #  </p>
  # </p>
  it 'opens and closes properly' do
    query_interface = RichUrls::QueryInterface.new
    query_interface.start(:p)
    query_interface.start(:p)
    query_interface.start(:a)
    query_interface.end(:a)
    expect(query_interface.elements[2].open).to eq(false)
    query_interface.end(:p)
    expect(query_interface.elements[1].open).to eq(false)
    query_interface.end(:p)
    expect(query_interface.elements[0].open).to eq(false)

    expect(query_interface.elements.length).to eq(3)
  end

  # structure is like:
  # <p>
  #   Start
  #   <p>
  #     Mid start
  #     <a>link mid mid</a>
  #     mid end
  #   </p>
  #   End
  # </p>
  it 'chains text together' do
    query_interface = RichUrls::QueryInterface.new
    query_interface.start(:p)
    query_interface.text("Start")
    query_interface.start(:p)
    query_interface.text("Mid start")
    query_interface.start(:a)
    query_interface.text("link mid mid")
    query_interface.end(:a)
    query_interface.text("mid end")
    query_interface.end(:p)
    query_interface.text("End")
    query_interface.end(:p)

    expect(query_interface.elements[0].attributes[:text])
      .to eq('Start Mid start link mid mid mid end End')
  end

  it 'adds attributes' do
    query_interface = RichUrls::QueryInterface.new
    query_interface.start(:p)
    query_interface.attr(:x, 'y')

    expect(query_interface.elements[0].attributes[:x]).to eq('y')
  end
end
