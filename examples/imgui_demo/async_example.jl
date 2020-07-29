## run app.jl then define the following function
myhook = true
function button_test(store)
    while myhook
        if get_state(store).buttons["basic_button"].button.is_triggered
            @warn "This triggers $(@__FILE__):$(@__LINE__)."
        end
        yield()
    end
end

## then call the function asyncly
t = @async button_test(store)

# click the button to see what happens

## then set `myhook` to false and the function will exit
myhook = false
@show t

## update the function and turn on `myhook` again
myhook = true
t = @async button_test(store)

## this is basically how to interactively connect/disconnect functions from the UI
# there is no callback functions or signals involved, all we need is just a well-managed
# global state along with naive Julia tasks.
