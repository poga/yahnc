host = "http://106.187.52.200:3000"
$ \#submit-form .toggle!

linksRef = new PgBase "#host/links"

window.LINK2ITEM = (link) ->
  """
      <div class="item">
        <div class="right floated tiny teal">#{moment(link.create_date).fromNow!}</div>
        <div class="content">
          <a class="header link-click" data-id="#{link._id}">#{link.title}</a>
          <div class="description">
            <i class="red arrow up icon"></i>
            #{link.rating}
            #{link.url}
            </div>
        </div>
      </div>
      """

window.GET_COMMENT = (link_id, cb) ->
  socketRef = new PgBase "#host/comments"
  console.log socketRef
  socketRef.need-connection!
  <- socketRef.socket.emit "GET:comments", { q: "{\"link_id\":#link_id}" }
  cb it

linksRef.once \value, ->
  for link in it.reverse!
    $(\#link-list).append LINK2ITEM(link)
  console.log \value, it

linksRef.on \child_added, ->
  $(\#link-list).prepend LINK2ITEM(it)
  console.log \added, it

<- $
$ \#show-submit .on \click, ->
  $ \#submit-form .toggle!

$ \#go-to-hot .on \click, ->
  $ \#submit-form .hide!

$ \#submit-button .on \click, ->
  link =
    title: $(\#submit-title).val!,
    url: $(\#submit-link).val!,
    rating: 0
  linksRef.push link
  $(\#submit-title).val ""
  $(\#submit-link).val ""

$ \body .on \keypress, \#comment-input ->
  if it.keyCode == 13
    commentRef = new PgBase "#host/comments"
    link_id = $(it.target).data(\link-id)
    link_body = $(it.target).val!
    new_comment =
      link_id: link_id
      body: link_body
    $(it.target).val("")
    <- commentRef.push new_comment
    $(\#comment-sect).prepend """
      <div class="ui secondary segment">
        <p>#link_body</p>
      </div>
    """

$ \body .on \click, \.link-click ->
  id = $(it.target).data("id")
  console.log id
  postRef = new PgBase "#host/links/#id"
  <- postRef.once \value
  console.log it
  $(\#main).html """
    <h2 class="ui header">
    #{it.title}
    <div class="sub header"><i class="red arrow up icon"></i>
            #{it.rating}
            #{it.url}
                </div>
        </h2>
        <div class="ui input focus fluid icon">
          <input type="text" placeholder="Leave comment..." id="comment-input" data-link-id="#{it._id}">
          <i class="outline comment icon"></i>
        </div>
      </div>
    </div>
    <div id="comment-sect" style="padding-top: 20px"></div>
  """
  <- GET_COMMENT id
  console.log it
  for c in it.entries.reverse!
    $(\#comment-sect).append """
      <div class="ui secondary segment">
        </h3>
        <p>#{c.body}</p>
      </div>
    """
