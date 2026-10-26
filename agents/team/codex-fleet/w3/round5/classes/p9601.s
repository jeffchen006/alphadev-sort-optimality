# n=5 model=out iset=I1 prefix14_class=9601
mov S2, P3
mov S1, P0
cmp P1, S1
cmovle S1, P1
cmovg P0, P1
cmp P2, S2
cmovge S2, P2
cmovg P2, P3
mov S0, P0
cmp S0, S2
cmovge S0, S2
cmovg S2, P0
cmp P2, S1
cmovge P3, S1
