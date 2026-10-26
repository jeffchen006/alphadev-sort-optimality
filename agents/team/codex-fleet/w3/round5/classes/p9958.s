# n=5 model=out iset=I1 prefix14_class=9958
cmp P1, P0
cmovge S2, P0
cmovle S2, P1
cmovge P0, P1
cmp P2, P3
mov S0, P2
cmovg P2, P3
cmovg P3, S0
cmp P0, P3
cmovg S1, P0
cmovg P0, P3
cmovg P3, S1
mov P3, S2
cmp P3, P2
