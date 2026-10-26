# n=5 model=out iset=I1 prefix14_class=9808
mov S0, P3
mov S2, P2
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmp P0, P2
mov S1, S0
cmovle P2, P0
cmovl P0, S2
cmp P0, S0
cmovg S0, P0
cmovge P0, S1
cmp P1, P2
cmovle S0, P2
