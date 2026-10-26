# n=5 model=out iset=I1 prefix14_class=7540
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovl S0, P3
cmp P1, P0
cmovge S1, P0
mov P3, S0
cmovge P0, P1
cmovge P1, S1
cmp S0, P1
cmovle P3, P1
cmovle P1, S0
cmp P0, P2
cmovle S0, P0
