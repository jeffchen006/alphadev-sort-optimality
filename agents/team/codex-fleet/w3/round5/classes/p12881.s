# n=5 model=out iset=I1 prefix14_class=12881
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovle P3, S2
cmp P1, P2
cmovle S1, P1
cmovg S1, P2
cmovle P1, P2
cmovle P2, S1
cmp P2, P0
cmovg S1, P0
cmovl P2, P0
cmovg P0, P2
mov S0, P1
