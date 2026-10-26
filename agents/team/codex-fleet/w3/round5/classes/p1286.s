# n=5 model=out iset=I1 prefix14_class=1286
cmp P0, P2
cmovg S1, P2
cmovg P2, P0
cmovg P0, S1
mov S0, P2
mov S2, P1
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmp P2, S2
cmovle S0, S2
cmovg P2, S2
cmp P0, P3
mov S0, P0
