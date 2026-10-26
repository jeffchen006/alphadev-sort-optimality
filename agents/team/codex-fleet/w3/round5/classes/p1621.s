# n=5 model=out iset=I1 prefix14_class=1621
mov S1, P2
cmp S1, P1
cmovge P2, P1
cmovl S1, P1
mov S0, P0
cmp P3, S0
cmovl S0, P3
mov S2, S0
cmovge P0, P3
cmp P2, S2
cmovle S2, P2
cmovle P2, S0
mov S0, P0
cmp S1, P0
