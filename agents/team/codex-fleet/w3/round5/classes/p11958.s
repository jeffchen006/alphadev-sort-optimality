# n=5 model=out iset=I1 prefix14_class=11958
cmp P3, P2
cmovg S1, P2
cmovg P2, P3
cmovle S1, P3
cmp P0, P1
mov S0, P0
cmovle S0, P1
cmovl P1, P0
cmp P2, S0
cmovge P0, P2
cmovge P2, S0
mov S2, S1
cmovge S0, P0
cmp S2, P1
