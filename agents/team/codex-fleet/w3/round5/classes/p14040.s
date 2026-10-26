# n=5 model=out iset=I1 prefix14_class=14040
cmp P2, P0
cmovg S2, P2
cmovge P2, P0
cmovg P0, S2
mov S1, P3
cmp P3, P1
cmovg P3, P1
cmovge P1, S1
mov S0, P3
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp S0, P2
