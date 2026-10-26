# n=5 model=out iset=I1 prefix14_class=5298
mov S2, P1
cmp P1, P3
cmovge P1, P3
mov S1, P0
cmovg P3, S2
cmp S1, P2
cmovge P0, P2
mov S2, P0
cmovle S1, P2
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmp S1, P3
cmovge S0, S1
