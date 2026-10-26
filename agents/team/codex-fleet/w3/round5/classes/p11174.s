# n=5 model=out iset=I1 prefix14_class=11174
mov S1, P0
cmp S1, P1
cmovge P0, P1
mov S0, P0
cmovg P1, S1
cmp P3, P2
mov S2, P2
cmovle P2, P3
cmovg S2, P3
cmp P1, S2
cmovl P3, S2
cmovle S2, P1
cmovl P1, P3
cmp P0, P2
