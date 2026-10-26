# n=5 model=out iset=I1 prefix14_class=1800
cmp P1, P0
mov S0, P0
cmovg S0, P1
cmovge P1, P0
cmp P3, P2
mov S1, P2
cmovge S1, P3
cmovge P3, P2
cmp S1, S0
mov P2, S0
cmovle S0, S1
cmovl S1, P2
cmp P1, P3
mov S1, P3
