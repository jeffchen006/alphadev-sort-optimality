# n=5 model=out iset=I1 prefix14_class=8097
cmp P3, P2
mov S2, P3
cmovle P3, P2
cmovge S2, P2
cmp P0, P1
cmovg S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P0, S2
cmovle S0, S2
mov S1, P1
cmovle S2, P0
cmovl P0, S0
cmp P3, S1
