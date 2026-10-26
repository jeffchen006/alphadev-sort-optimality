# n=5 model=out iset=I1 prefix14_class=9115
mov S0, P0
cmp P0, P1
cmovl P0, P1
cmovg S0, P1
mov S1, S0
cmp P2, P3
cmovge P1, P2
cmovg P2, P3
cmovg P3, P1
cmp P2, S1
cmovle S1, P2
cmovg S0, P2
cmp P0, P3
cmovg P1, P0
