# n=5 model=out iset=I1 prefix14_class=7532
cmp P3, P0
mov S1, P0
cmovg P0, P3
cmovle S1, P3
cmp P1, P2
mov S0, S1
cmovge P3, P2
cmovg P2, P1
cmovg P1, P3
cmp S1, P1
cmovle S0, P1
cmovle P1, S1
cmp P2, P0
cmovl P3, P2
