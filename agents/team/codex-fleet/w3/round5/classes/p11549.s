# n=5 model=out iset=I1 prefix14_class=11549
mov S2, P0
cmp P1, S2
mov S0, P2
cmovle P0, P1
mov S1, P0
cmovle P1, S2
cmp P3, S0
cmovl P2, P3
cmovg S0, P3
cmp P2, S1
cmovg S1, P2
cmovg P2, P0
cmp P1, S0
cmovge S2, S0
