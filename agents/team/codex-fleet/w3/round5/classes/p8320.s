# n=5 model=out iset=I1 prefix14_class=8320
mov S2, P2
cmp S2, P1
cmovle P2, P1
mov S1, P0
cmovle P1, S2
cmp S1, P3
mov S0, P1
cmovle S1, P3
cmovg P0, P3
cmp S0, P0
cmovl S0, P0
cmovge P1, P0
cmp P2, S1
cmovge P1, P2
