# n=5 model=out iset=I1 prefix14_class=7453
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovge P1, P2
mov P2, P0
cmp P2, P3
cmovl P2, P3
cmovl P3, P0
cmp S0, P3
cmovg P0, P3
cmovg P3, S0
cmovle P0, S0
mov S0, P1
cmp P1, P2
