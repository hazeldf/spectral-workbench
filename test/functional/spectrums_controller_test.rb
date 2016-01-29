require 'test_helper'

class SpectrumsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spectrums)
  end

  test "should create spectrum" do
    session[:user_id] = User.first.id # log in
    post :create, dataurl: "data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7",
      spectrum: {
        user_id: session[:user_id],
        author: User.first.login,
        title: "One nice spectrum",
        video_row: 5,
        #calibration_id: spectrums(:one).id, # clone calibration
        notes: "A test spectrum."
    }
    assert_not_nil :spectrum
    assert_equal 'Spectrum was successfully created.', flash[:notice]
    assert_redirected_to spectrum_path(assigns(:spectrum))
  end

  test "should show spectrum" do
    get :show, :id => spectrums(:one).id
    assert_response :success # to /analyze/spectrums/#, lets update this
    assert_nil assigns(:spectrums)
    assert_not_nil assigns(:spectrum)
  end

  test "should show spectrum json" do
    get :show, :id => spectrums(:one).id, :format => :json
    assert_response :success
  end

  test "should show spectrum csv" do
    get :show, :id => spectrums(:one).id, :format => :csv
    assert_response :success
  end

  test "should show spectrum xml" do
    get :show, :id => spectrums(:one).id, :format => :xml
    assert_response :success
  end

  test "should show latest snapshot in json" do
    get :latest, :id => snapshots(:one).id, :format => :json
    assert_response :success
  end

  test "should show latest snapshot csv" do
    get :latest, :id => snapshots(:one).id, :format => :csv
    assert_response :success
  end

  test "should show latest snapshot xml" do
    get :latest, :id => snapshots(:one).id, :format => :xml
    assert_response :success
  end

  test "should show spectrum embed" do
    get :embed, :id => spectrums(:one).id
    assert_response :success
    assert_not_nil :spectrum
  end

  test "should show search" do
    get :search, :id => "cfl"
    assert_response :success
    assert_not_nil :spectrums
    assert_not_nil :sets
  end

  test "should respond to choose" do
    session[:user_id] = User.first.id # log in
    get :choose, :id => 'calibration'
    assert_response :success
    assert_not_nil :spectrums
  end

  test "should respond to choose in JSON" do
    session[:user_id] = User.first.id # log in
    get :choose, :id => 'calibration', :format => :json
    assert_response :success
    assert_not_nil :spectrums
  end

  test "should respond with 'No results' to invalid search" do
    session[:user_id] = User.first.id # log in
    get :choose, :id => 'calibration'
    assert_response :success
    assert_equal @response.body, "<p>No results</p>\n"
  end

  test "should respond to choose with partial tagname" do
    session[:user_id] = User.first.id # log in

    spectrums(:one).tag( "calibration:#{spectrums(:two).id}",
                         User.first.id )
    assert Tag.where('name LIKE (?)', 'calibration%')

    get :choose, :id => 'calibration'

    assert_response :success
    assert_not_equal assigns(:spectrums), []
    assert_equal assigns(:spectrums).first.id, spectrums(:one).id
  end

  test "should respond to choose with spectrum ID" do
    session[:user_id] = User.first.id # log in

    get :choose, :id => spectrums(:one).id

    assert_response :success
    assert_not_equal assigns(:spectrums), []
    assert_equal assigns(:spectrums).first.id, spectrums(:one).id
  end

  test "should respond to choose with title beginning" do
    session[:user_id] = User.first.id # log in

    assert spectrums(:one).id != nil
    spectrums(:one).title = "Elephant spectrum"
    spectrums(:one).save

    get :choose, :id => 'Elephant'
    assert_response :success
    assert_not_equal assigns(:spectrums), []
    assert_equal assigns(:spectrums).first.id, spectrums(:one).id
  end

  test "should respond to choose with no terms" do
    session[:user_id] = User.first.id # log in
    get :choose, :id => ''
    assert_response :success
    assert_not_nil :spectrums
  end

  test "should get edit" do
    session[:user_id] = User.first.id # log in
    get :edit, :id => spectrums(:one).id
    assert_response :success
  end

  test "should update spectrum" do
    session[:user_id] = User.first.id # log in
    put :update, :id => spectrums(:one).id, :spectrum => { }
    assert_response :redirect
    assert_equal 'Spectrum was successfully updated.', flash[:notice]
    assert_not_nil :spectrum
    assert_redirected_to spectrum_path(assigns(:spectrum))
  end

  test "should calibrate spectrum" do
    session[:user_id] = User.first.id # log in
    # we need a real spectrum with an image to work with:
    spectrum = Spectrum.last
    spectrum.image_from_dataurl("data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7")
    spectrum.save
    put :calibrate, :id => spectrum.id, :x1 => 0, :x2 => 10, :w1 => 400, :w2 => 500
    assert_response :redirect
    assert_equal 'Great, calibrated!', flash[:notice][0..17]
    assert_redirected_to spectrum_path(spectrum)
  end

  test "should clone spectrum calibration" do
    session[:user_id] = User.first.id # log in
    # we need a real spectrum with an image to work with:
    spectrum = Spectrum.last
    spectrum.image_from_dataurl("data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7")
    spectrum.save
    put :clone_calibration, :id => spectrum.id, :clone_id => spectrums(:one).id
    assert_response :redirect
    assert_equal 'Spectrum was successfully calibrated.', flash[:notice]
    assert_redirected_to spectrum_path(spectrum)
  end

  test "should fork spectrum" do
    session[:user_id] = User.first.id # log in
    # we need a real spectrum with an image to work with:
    spectrum = Spectrum.last
    spectrum.image_from_dataurl("data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7")
    spectrum.save
    get :fork, :id => spectrums(:one).id
    assert_response :redirect
    assert_equal Spectrum.last.tags.last.name, "forked:#{spectrums(:one).id}"
  end

  test "should not destroy spectrum if not owner" do
    session[:user_id] = users(:aaron).id # log in
    current_user = users(:aaron) # log in
    assert_not_equal current_user.id, spectrums(:one).user_id
    assert_not_equal current_user.role, "admin"
    assert_difference('Spectrum.count', 0) do
      delete :destroy, :id => spectrums(:one).id
    end
    assert_redirected_to spectrum_path(spectrums(:one))
  end

  test "should destroy spectrum" do
    session[:user_id] = spectrums(:one).user.id # log in
    current_user = spectrums(:one).user # log in
    assert_equal current_user.id, spectrums(:one).user.id
    assert_difference('Spectrum.count', -1) do
      delete :destroy, :id => spectrums(:one).id
    end
    assert_redirected_to '/'
  end

  test "should destroy spectrum if admin" do
    session[:user_id] = users(:admin).id # log in
    current_user = users(:admin) # log in
    spectrum = Spectrum.last
    assert_not_equal spectrum.user_id, current_user.id
    spectrum.save
    assert_difference('Spectrum.count', -1) do
      delete :destroy, :id => spectrum.id
    end
    assert_redirected_to '/'
  end

end
