# n=5 model=out iset=I1 prefix14_class=1491
mov S0, P1
mov S1, P3
cmp P3, P0
cmovle S1, P0
cmovge P3, P0
cmp P1, P2
mov S2, P3
cmovle P1, P2
cmovl P2, S0
cmp P1, S1
cmovge S0, S1
cmovg S1, P1
cmovg P1, S0
cmp P2, S2
