module Shoes::Types
  def open_client_edit_window(client, shoes_object, method)
    window :title => "#{client.first_name} #{client.last_name}" do
      @main_app = shoes_object
      @refresh_history = method
      stack do
        def edit_client_flow(client_object, caption, getter, setter)
          edit = flow
          slot = stack(:width => 200){ para "#{caption}: #{client_object.send getter}" }
          button = stack(:width => 1) do
            button 'edit' do
              edit.show()
              button.hide()
            end
          end
          edit = flow(:width => 500) do
            update = edit_line
            button 'Add' do
              client_object.send setter, update.text
              slot.clear{ para "#{caption}: #{client_object.send getter}" }
              edit.hide()
              button.show()
              @main_app.send(@refresh_history)
            end
          end
          edit.hide()
        end

        flow do
          edit_client_flow(client, "First Name", :first_name, :first_name=)
        end

        flow do
          edit_client_flow(client, "Last Name", :last_name, :last_name=)
        end

        flow do
          edit_client_flow(client, "Email", :email, :email=)
        end

        flow do
          edit_client_flow(client, "Phone", :phone, :phone=)
        end
      end
    end
  end


end
