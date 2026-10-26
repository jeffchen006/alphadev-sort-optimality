# n=5 model=out iset=I1 prefix14_class=13735
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
mov S0, P1
cmp S0, P0
cmovge P1, P0
cmovl S0, P0
mov P0, P3
cmp S0, P0
cmovge P3, S0
cmovg S0, P0
cmp P1, P2
mov P3, S0
