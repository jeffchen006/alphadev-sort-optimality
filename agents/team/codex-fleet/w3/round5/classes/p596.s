# n=5 model=out iset=I1 prefix14_class=596
cmp P3, P1
cmovle S2, P3
mov S1, P0
cmovg S2, P1
cmovl P3, P1
cmovg P1, P3
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmp P2, P1
cmovl P1, P2
cmovg P3, P2
cmp S2, S1
cmovg S0, S2
