require 'spec_helper'

describe "User pages" do
  context "Show" do
    it "requires a logged in user" do
      @user = Fabricate(:user)
      visit user_path(@user)
      current_path.should == root_path
    end

    context "viewing my own page" do
      before do
        simulate_signed_in
      end

      context "filters" do
        it "unarchived links by default" do
          new_link = Fabricate(:link_save, :user => @user, :archived => false)
          old_link = Fabricate(:link_save, :user => @user, :archived => true)
          visit user_path(@user)
          page.should have_link new_link.title
          page.should_not have_link old_link.title
        end

        it "archived and unarchived links when I ask for them" do
          new_link = Fabricate(:link_save, :user => @user, :archived => false)
          old_link = Fabricate(:link_save, :user => @user, :archived => true)
          visit user_path(@user)
          page.click_link "view archived"
          page.should have_link new_link.title
          page.should have_link old_link.title
        end
      end

      context "sorts" do
        it "by save date by default" do
          old_ls = Fabricate(:link_save, :user => @user, :created_at => 3.years.ago)
          new_ls = Fabricate(:link_save, :user => @user, :created_at => 3.minutes.ago)
          med_ls = Fabricate(:link_save, :user => @user, :created_at => 3.days.ago)
          visit user_path(@user)
          within("#list_box li:first-child") do
            page.should have_link new_ls.title
          end
          within("#list_box li:last-child") do
            page.should have_link old_ls.title
          end
        end

        it "by popularity default when requested" do
          boring = Fabricate(:link_save, :user => @user)
          3.times { Fabricate(:click, link: boring.link) }
          popular = Fabricate(:link_save, :user => @user)
          9.times { Fabricate(:click, link: popular.link) }
          pretty_good = Fabricate(:link_save, :user => @user)
          5.times { Fabricate(:click, link: pretty_good.link) }

          visit user_path(@user)
          click_link "by popularity"
          within("#list_box li:first-child") do
            page.should have_link popular.title
          end
          within("#list_box li:last-child") do
            page.should have_link boring.title
          end
        end
      end
    end
  end
end