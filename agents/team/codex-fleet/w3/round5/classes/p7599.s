# n=5 model=out iset=I1 prefix14_class=7599
mov S0, P1
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovg P1, P0
cmp P2, P3
cmovg S2, P2
cmovge P2, P3
cmovg P3, S2
mov S1, P3
cmp P1, P2
cmovle P1, P2
cmovl P2, P0
cmp S0, P3
