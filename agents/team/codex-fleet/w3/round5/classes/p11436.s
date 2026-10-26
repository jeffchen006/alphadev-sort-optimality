# n=5 model=out iset=I1 prefix14_class=11436
cmp P0, P1
mov S0, P0
cmovge P0, P1
mov S1, P3
cmovle S0, P1
cmp S1, P2
cmovl S1, P2
cmovge P3, P2
cmp P0, P3
cmovle P1, P0
cmovge P1, P3
cmovge P3, P0
cmp S1, S0
cmovge P0, S1
