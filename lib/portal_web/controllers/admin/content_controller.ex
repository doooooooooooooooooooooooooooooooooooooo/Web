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

  # 处理文件上传并返回参数
  defp handle_file_upload(params) do
    case params["cover_image"] do
      %Plug.Upload{} = upload ->
        # 生成唯一的文件名
        extension = Path.extname(upload.filename)
        filename = "#{Ecto.UUID.generate()}#{extension}"
        upload_path = Path.join("priv/static/uploads", filename)

        # 确保上传目录存在
        File.mkdir_p!(Path.dirname(upload_path))

        # 复制文件到上传目录
        case File.cp(upload.path, upload_path) do
          :ok ->
            # 返回相对路径用于数据库存储
            Map.put(params, "cover_image", "/uploads/#{filename}")

          {:error, _reason} ->
            params
        end

      _ ->
        params
    end
  end

  # 处理新建表单提交
  def create(conn, %{"content" => content_params}) do
    processed_params = handle_file_upload(content_params)

    case Contents.create_content(processed_params) do
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
        processed_params = handle_file_upload(content_params)

        case Contents.update_content(content, processed_params) do
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
