require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "case of duplication" do
    before do
      @user = User.create(
        first_name: "Joe",
        last_name: "Tester",
        email: "joetester@example.com",
        password: "dottle-nouveau-pavilion-tights-furze"
      )
      @user.projects.create(
        name:"Test Project",
      )
    end
    # ユーザー単位では重複したプロジェクト名を許可しないこと
    it "does not allow duplicate project names per user" do
      new_project = @user.projects.build(
        name:"Test Project",
      )
      new_project.valid?
      expect(new_project.errors[:name]).to include("has already been taken")
    end

    it "allows two users to share a project name" do
      other_user = User.create(
        first_name: "Jane",
        last_name: "Tester",
        email: "janetester@example.com",
        password: "dottle-nouveau-pavilion-tights-furze"
      )
      other_project = other_user.projects.create(
        name: "Test Project",
      )
      expect(other_project).to be_valid
    end
  end


  describe "late status" do
    # 締め切り日が過ぎていれば遅延していること
    it "is late when tha due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締め切り日が今日ならスケジュール通りであること
    it "is no time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締め切り日が未来ならスケジュール通りであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
  # たくさんのメモがついていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
