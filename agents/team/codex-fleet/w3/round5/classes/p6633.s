# n=5 model=out iset=I1 prefix14_class=6633
cmp P0, P3
cmovge S2, P3
cmovle S2, P0
mov S0, P2
cmovl P0, P3
cmp S0, P1
cmovg P2, P1
cmovle S0, P1
cmp P0, S0
cmovle S1, S0
cmovg S1, P0
cmovge P0, S0
mov S1, S2
cmp S2, P2
