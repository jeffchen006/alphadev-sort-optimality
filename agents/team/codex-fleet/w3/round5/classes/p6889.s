# n=5 model=out iset=I1 prefix14_class=6889
cmp P2, P0
mov S1, P0
cmovle S1, P2
cmovl P2, P0
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovle S0, P1
cmp P2, S0
mov S2, S0
cmovge S0, P2
cmovle S2, P2
cmp S1, P3
cmovge P2, S2
