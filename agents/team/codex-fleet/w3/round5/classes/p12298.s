# n=5 model=out iset=I1 prefix14_class=12298
cmp P1, P0
cmovle S2, P0
cmovge S2, P1
cmovle P0, P1
cmovge P1, P0
cmp P3, P2
cmovg S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P0, P3
cmovle P1, P3
cmovg P0, P3
cmp S2, P2
mov S0, P2
