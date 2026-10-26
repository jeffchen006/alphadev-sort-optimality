# n=5 model=out iset=I1 prefix14_class=9681
mov S1, P0
cmp P3, P2
mov S2, P3
cmovl P3, P2
cmovg S2, P2
cmp P1, S1
cmovle P0, P1
cmovle P1, S1
cmp P1, P3
cmovge P2, P3
cmovg P3, P1
cmovg P1, P2
cmp P0, S2
mov S0, S2
