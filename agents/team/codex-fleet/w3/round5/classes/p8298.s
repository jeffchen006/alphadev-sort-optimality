# n=5 model=out iset=I1 prefix14_class=8298
mov S1, P2
cmp P2, P0
cmovg S1, P0
mov S0, S1
cmovg P0, P2
cmp P1, P3
cmovle P2, P3
cmovle P3, P1
cmovle P1, P2
cmp S1, P3
cmovge S1, P3
cmovle S0, P3
cmp P1, P0
cmovg S2, P0
