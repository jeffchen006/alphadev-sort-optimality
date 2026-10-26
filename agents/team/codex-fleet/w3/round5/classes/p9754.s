# n=5 model=out iset=I1 prefix14_class=9754
cmp P1, P3
cmovle S2, P3
mov S1, P2
cmovl P3, P1
cmovle P1, S2
cmp P0, S1
mov S0, P1
cmovle P2, P0
cmovl P0, S1
cmp P0, S0
cmovg P1, P0
cmovge P0, S0
mov S0, P0
mov S1, P2
