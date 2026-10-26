# n=5 model=out iset=I1 prefix14_class=1637
cmp P2, P0
mov S0, P2
mov S1, P1
cmovge P2, P0
cmovle S0, P0
cmp P3, S1
cmovl S1, P3
cmovge P1, P3
cmp P2, S1
mov S2, P2
cmovle P2, S1
cmovg S2, S1
cmp S0, P1
cmovge S2, S0
