# n=5 model=out iset=I1 prefix14_class=10611
cmp P3, P2
cmovge S1, P2
cmovle S1, P3
cmovge P2, P3
mov S2, P1
mov S0, P2
cmp S2, P0
cmovg P1, P0
cmovle S2, P0
cmp P2, S2
cmovl P2, S2
cmovg S0, S2
cmp P1, S1
cmovge P3, S1
