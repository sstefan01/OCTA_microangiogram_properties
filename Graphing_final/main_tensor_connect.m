function [skel, Sc] = main_tensor_connect(skel,S,seg)

    disp('Creating scalar field')
    Sc = gap_correct_vectors(skel,seg,S);
    disp('Connecting endpoints using scalar field')
    skel = conn_end(Sc, skel,S);
    
end