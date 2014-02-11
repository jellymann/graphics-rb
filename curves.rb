require_relative './gfx.rb'

include Graphics

window do
  title 'Curves'
  exit_on_close
  # wireframe

  init do
    glEnable GL_CULL_FACE
    glEnable GL_DEPTH_TEST

    shader :simple do
      vertex 'vertex.glsl'
      fragment 'fragment.glsl'
    end

    camera :main do
      eye 5, 3, 5
      at 0, 0, 0
      up 0, 1, 0
    end

    perspective :main do
      fovy 45
      z_near 0.5
      z_far 100
    end

    add_control CameraControl.new :main

    mesh :cube do
      cube
    end

    mesh :quad do
      quad
    end

    spline :a do
      control_point -0.5,-3.5, 0, 2
      control_point 3.5, 1.5, 0
      control_point 0.5, 4.5, 0
      control_point 6, 6, 0, 2
      control_point 1, 4, 0
      control_point 4, 1, 0
      control_point 0,-4, 0, 2
      control_point 6,-6, 0, 2
      control_point 0,-6, 0, 2
    end

    spline :b do
      control_point  1, 0, 0
      control_point  0, 0, 1
      control_point -1, 0, 0
      control_point  0, 0,-1
      control_point  1, 0, 0
    end

    mesh :spline do
      lathe :a, {step_s: 0.01, step_t: 0.01}
      # sweep :a, :b, {step_s: 0.01, step_t: 0.01}
    end

    cube_shape = shape :cube do
      use_mesh :cube
      colour 1, 0, 0
      position 0, 1, 0
      uniform_scale 2
    end

    floor = shape do
      use_mesh :quad
      colour 0, 1, 0
      position 0, -6, 0
      uniform_scale 20
    end

    spline_shape = shape do
      use_mesh :spline
      colour 1, 0, 0
    end

    cp_shapes = []

    splines[:a].each_control_point do |p|
      cp_shapes << shape do
        use_mesh :cube
        colour 1, 0, 1
        position p.x, p.y, p.z
        uniform_scale 0.1
      end
    end

    viewport :main do
      bg 0, 1, 1
      use_camera :main
      use_lense :main

      before_each_frame do
        use_shader :simple
      end

      each_frame do

        # draw_shape :cube
        # cube_shape.rotation += Vector[0,1,0]

        spline_shape.draw

        cp_shapes.each { |s| s.draw }

        floor.draw
      end
    end
  end
end
