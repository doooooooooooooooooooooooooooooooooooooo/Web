defmodule Portal.Contents do
  import Ecto.Query
  alias Portal.Repo
  alias Portal.Content

  # 获取所有内容
  def list_contents do
    Repo.all(from(c in Content, order_by: [desc: c.inserted_at]))
  end

  # 获取单个内容
  def get_content(id) do
    Repo.get(Content, id)
  end

  # 创建内容
  def create_content(attrs) do
    %Content{}
    |> Content.changeset(attrs)
    |> Repo.insert()
  end

  # 更新内容
  def update_content(%Content{} = content, attrs) do
    content
    |> Content.changeset(attrs)
    |> Repo.update()
  end

  # 删除内容
  def delete_content(%Content{} = content) do
    Repo.delete(content)
  end
end
