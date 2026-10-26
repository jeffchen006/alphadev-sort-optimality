# n=5 model=out iset=I1 prefix14_class=7648
mov S2, P0
cmp P2, S2
cmovle P0, P2
cmovge S2, P2
cmp P3, P1
cmovg S1, P1
cmovle S1, P3
cmovge P1, P3
cmp P0, S1
cmovle P3, P0
cmovle P0, S1
mov S0, P1
cmovl S1, P3
cmp S2, S0
