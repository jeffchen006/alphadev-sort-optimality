# n=5 model=out iset=I1 prefix14_class=3933
mov S0, P3
cmp P1, P2
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovge P3, P0
cmp P1, S0
cmovle S2, P1
cmovl P1, S0
cmovle S0, S2
cmp P3, P2
