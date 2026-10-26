# n=5 model=out iset=I1 prefix14_class=12084
cmp P1, P2
mov S0, P1
cmovg S0, P2
cmovle P1, P2
mov S1, P0
cmp S1, P3
cmovge P0, P3
cmovge P3, S1
cmovg S1, P0
cmp S0, S1
cmovl S1, S0
cmovge P0, S0
cmp P3, P1
cmovge S1, P3
