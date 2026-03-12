defmodule PortalWeb.Admin.ContentController do
  use PortalWeb, :controller

  alias Portal.Contents
  alias Portal.Content

  # 显示列表页面
  def index(conn, _params) do
    contents = Contents.list_contents()
    render(conn, :index, contents: contents)
  end

  # 显示单个内容
  def show(conn, %{"id" => id}) do
    case Contents.get_content(id) do
      nil ->
        conn
        |> put_flash(:error, "内容不存在")
        |> redirect(to: ~p"/admin/contents")

      content ->
        render(conn, :show, content: content)
    end
  end

  # 显示新建表单
  def new(conn, _params) do
    changeset = Content.changeset(%Content{}, %{})
    render(conn, :new, changeset: changeset)
  end

  # 处理文件上传
  defp handle_upload(conn, content_params) do
    case Map.get(conn.params, "cover_image") do
      %Plug.Upload{path: path, filename: filename} ->
        # 真正有文件上传
        ext = Path.extname(filename)
        new_filename = "#{System.system_time(:second)}#{ext}"
        dest = Path.join(["priv", "static", "uploads", new_filename])
        File.cp!(path, dest)
        Map.put(content_params, "cover_image", "/uploads/#{new_filename}")

      _ ->
        # 没有文件，保持原样
        content_params
    end
  end

  # 处理新建表单提交
  def create(conn, %{"content" => content_params}) do
    content_params = handle_upload(conn, content_params)

    case Contents.create_content(content_params) do
      {:ok, _content} ->
        conn
        |> put_flash(:info, "内容创建成功")
        |> redirect(to: ~p"/admin/contents")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  # 显示编辑表单
  def edit(conn, %{"id" => id}) do
    case Contents.get_content(id) do
      nil ->
        conn
        |> put_flash(:error, "内容不存在")
        |> redirect(to: ~p"/admin/contents")

      content ->
        changeset = Content.changeset(content, %{})
        render(conn, :edit, content: content, changeset: changeset)
    end
  end

  # 处理编辑表单提交
  def update(conn, %{"id" => id, "content" => content_params}) do
    case Contents.get_content(id) do
      nil ->
        conn
        |> put_flash(:error, "内容不存在")
        |> redirect(to: ~p"/admin/contents")

      content ->
        content_params = handle_upload(conn, content_params)

        case Contents.update_content(content, content_params) do
          {:ok, _content} ->
            conn
            |> put_flash(:info, "内容更新成功")
            |> redirect(to: ~p"/admin/contents")

          {:error, changeset} ->
            render(conn, :edit, content: content, changeset: changeset)
        end
    end
  end

  # 处理删除
  def delete(conn, %{"id" => id}) do
    case Contents.get_content(id) do
      nil ->
        conn
        |> put_flash(:error, "内容不存在")
        |> redirect(to: ~p"/admin/contents")

      content ->
        Contents.delete_content(content)

        conn
        |> put_flash(:info, "内容删除成功")
        |> redirect(to: ~p"/admin/contents")
    end
  end
end
