# n=5 model=out iset=I1 prefix14_class=10862
cmp P0, P2
cmovge S0, P2
mov S2, P3
cmovge P2, P0
cmovg P0, S0
mov S1, P2
cmp P1, P3
cmovg P3, P1
cmovle S2, P1
cmp P3, P2
cmovg S1, P3
cmovl P2, P3
cmp P0, S2
cmovle P3, S2
