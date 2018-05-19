module WelcomesHelper
  def full_title(page_title = '')
    base_title = "单词本"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end   
end
